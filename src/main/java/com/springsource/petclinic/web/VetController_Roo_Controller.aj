// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.springsource.petclinic.web;

import com.springsource.petclinic.domain.Vet;
import com.springsource.petclinic.reference.Specialty;
import java.lang.Long;
import java.lang.String;
import java.util.Arrays;
import java.util.Collection;
import javax.validation.Valid;
import org.joda.time.format.DateTimeFormat;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.core.convert.converter.Converter;
import org.springframework.core.convert.support.GenericConversionService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

privileged aspect VetController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST)
    public String VetController.create(@Valid Vet vet, BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("vet", vet);
            addDateTimeFormatPatterns(model);
            return "vets/create";
        }
        vet.persist();
        return "redirect:/vets/" + vet.getId();
    }
    
    @RequestMapping(params = "form", method = RequestMethod.GET)
    public String VetController.createForm(Model model) {
        model.addAttribute("vet", new Vet());
        addDateTimeFormatPatterns(model);
        return "vets/create";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public String VetController.show(@PathVariable("id") Long id, Model model) {
        addDateTimeFormatPatterns(model);
        model.addAttribute("vet", Vet.findVet(id));
        model.addAttribute("itemId", id);
        return "vets/show";
    }
    
    @RequestMapping(method = RequestMethod.GET)
    public String VetController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model model) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            model.addAttribute("vets", Vet.findVetEntries(page == null ? 0 : (page.intValue() - 1) * sizeNo, sizeNo));
            float nrOfPages = (float) Vet.countVets() / sizeNo;
            model.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            model.addAttribute("vets", Vet.findAllVets());
        }
        addDateTimeFormatPatterns(model);
        return "vets/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT)
    public String VetController.update(@Valid Vet vet, BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("vet", vet);
            addDateTimeFormatPatterns(model);
            return "vets/update";
        }
        vet.merge();
        return "redirect:/vets/" + vet.getId();
    }
    
    @RequestMapping(value = "/{id}", params = "form", method = RequestMethod.GET)
    public String VetController.updateForm(@PathVariable("id") Long id, Model model) {
        model.addAttribute("vet", Vet.findVet(id));
        addDateTimeFormatPatterns(model);
        return "vets/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public String VetController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model model) {
        Vet.findVet(id).remove();
        model.addAttribute("page", (page == null) ? "1" : page.toString());
        model.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/vets?page=" + ((page == null) ? "1" : page.toString()) + "&size=" + ((size == null) ? "10" : size.toString());
    }
    
    @ModelAttribute("specialtys")
    public Collection<Specialty> VetController.populateSpecialtys() {
        return Arrays.asList(Specialty.class.getEnumConstants());
    }
    
    Converter<Vet, String> VetController.getVetConverter() {
        return new Converter<Vet, String>() {
            public String convert(Vet vet) {
                return new StringBuilder().append(vet.getFirstName()).append(" ").append(vet.getLastName()).append(" ").append(vet.getAddress()).toString();
            }
        };
    }
    
    @InitBinder
    void VetController.registerConverters(WebDataBinder binder) {
        if (binder.getConversionService() instanceof GenericConversionService) {
            GenericConversionService conversionService = (GenericConversionService) binder.getConversionService();
            conversionService.addConverter(getVetConverter());
        }
    }
    
    void VetController.addDateTimeFormatPatterns(Model model) {
        model.addAttribute("vet_birthday_date_format", DateTimeFormat.patternForStyle("S-", LocaleContextHolder.getLocale()));
        model.addAttribute("vet_employedsince_date_format", DateTimeFormat.patternForStyle("S-", LocaleContextHolder.getLocale()));
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET, headers = "Accept=application/json")
    @ResponseBody
    public String VetController.showJson(@PathVariable("id") Long id) {
        return Vet.findVet(id).toJson();
    }
    
    @RequestMapping(method = RequestMethod.POST, headers = "Accept=application/json")
    public ResponseEntity<String> VetController.createFromJson(@RequestBody String json) {
        Vet.fromJsonToVet(json).persist();
        return new ResponseEntity<String>("Vet created", HttpStatus.CREATED);
    }
    
    @RequestMapping(headers = "Accept=application/json")
    @ResponseBody
    public String VetController.listJson() {
        return Vet.toJsonArray(Vet.findAllVets());
    }
    
    @RequestMapping(value = "/jsonArray", method = RequestMethod.POST, headers = "Accept=application/json")
    public ResponseEntity<String> VetController.createFromJsonArray(@RequestBody String json) {
        for (Vet vet: Vet.fromJsonArrayToVets(json)) {
            vet.persist();
        }
        return new ResponseEntity<String>("Vet created", HttpStatus.CREATED);
    }
    
}
